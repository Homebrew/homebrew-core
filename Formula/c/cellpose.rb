class Cellpose < Formula
  include Language::Python::Virtualenv

  desc "Generalist algorithm for cell and nucleus segmentation"
  homepage "https://www.cellpose.org/"
  url "https://files.pythonhosted.org/packages/0c/e4/3d4606883a5489b86fa6ab5f65b9d0a243810f64efb934033fe425089d5a/cellpose-4.2.1.1.tar.gz"
  sha256 "229eedea3977184202b2c87b3bd41c609facd742c7203bb4ad3cebd7b6bc6839"
  license "BSD-3-Clause"
  head "https://github.com/MouseLand/cellpose.git", branch: "main"

  depends_on "python-setuptools" => :build
  depends_on "numpy"
  depends_on "opencv"
  depends_on "python@3.14"
  depends_on "pytorch"
  depends_on "scipy"
  depends_on "torchvision"

  # imagecodecs is only needed by tifffile for optional compressed image formats.
  pypi_packages exclude_packages: %w[imagecodecs numpy opencv-python-headless scipy torch torchvision],
                extra_packages:   %w[cython pbr]

  resource "cython" do
    url "https://files.pythonhosted.org/packages/a9/d8/4981ef716ad0e3ff0d3ef383aefc6b03c4a88dee33b272bf8e0d833001ca/cython-3.3.0.tar.gz"
    sha256 "eed0d93fbca7087f143b42c34b05a825849bdf17f101572c2105acfa49aa88b8"
  end

  resource "fastremap" do
    url "https://files.pythonhosted.org/packages/22/3c/54d2378454d92ca1a894939d7db8b1a828ba45737e05532750520dd03e9f/fastremap-1.20.0.tar.gz"
    sha256 "a64ffb4a99fd06c6f54f0ffbf48c73532fa238c429a4278b45767a55957468a0"
  end

  resource "fill-voids" do
    url "https://files.pythonhosted.org/packages/f0/ca/b7be6906b27c5620df0ecff8ddbd00b81aa238ca24ec1f9e424cd3f3ff02/fill_voids-2.1.2.tar.gz"
    sha256 "2b9ef2753ffd2394a1948f9a11431a7ff084d4d7024509e0466b1b260be089df"
  end

  resource "natsort" do
    url "https://files.pythonhosted.org/packages/e2/a9/a0c57aee75f77794adaf35322f8b6404cbd0f89ad45c87197a937764b7d0/natsort-8.4.0.tar.gz"
    sha256 "45312c4a0e5507593da193dedd04abb1469253b601ecaf63445ad80f0a1ea581"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/6b/8d/ce438c28c7958e33184e8ac851ea2225b47a41e5e9e708fa3bddba631135/pbr-7.1.3.tar.gz"
    sha256 "9a4a85b84e906337708009af0b5f5cdabeeb72d4dc213c9e97974da54fd9acc5"
  end

  resource "roifile" do
    url "https://files.pythonhosted.org/packages/5f/2c/d0706309b51ee03c180d34cbe914150188f0d3cb9b7c31ce30c934910ad5/roifile-2026.9.22.tar.gz"
    sha256 "ba1de699dbabef664564cba6c021c2a01b47437d95b17d6ecf78287f46ef1a54"
  end

  resource "segment-anything" do
    url "https://files.pythonhosted.org/packages/4f/88/7725f418f2bb4a7ac2e5e8295fbbca2900c70c8fe5ba48b3aff5788af9a2/segment_anything-1.0.tar.gz"
    sha256 "ed0c9f6fb07bbef9c6238a7028a13c8272f1ba6b6305ca73e3e064266503736b"
  end

  resource "tifffile" do
    url "https://files.pythonhosted.org/packages/92/66/634db78ebad513038d753830dd8815eea26278b5463ba0f43198b0c24c4e/tifffile-2026.9.20.tar.gz"
    sha256 "30e145a7042ce7143ae50a50fe8b7221b0070aae22adab8f9e79a264be6b5cdc"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  allow_network_access! :build

  def install
    # Build Cython extensions without build isolation to avoid building another `numpy`
    no_isolation = %w[fastremap fill-voids]
    ENV["NO_CYTHON_COMPILE"] = "true"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resource("pbr")
    resources.each do |r|
      next if r.name == "pbr"

      venv.pip_install r, build_isolation: no_isolation.exclude?(r.name)
    end
    venv.pip_install_and_link buildpath

    # Load torchvision's virtualenv and its pytorch .pth file.
    # NOTE: This is an exception to our usual policy as building `pytorch` is complicated
    site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{formula_opt_libexec("torchvision")/site_packages}')\n"
    (venv.site_packages/"homebrew-torchvision.pth").write pth_contents
  end

  test do
    assert_match "--pretrained_model", shell_output("#{bin}/cellpose --help")

    (testpath/"test.py").write <<~PYTHON
      import numpy as np
      from cellpose import dynamics, metrics

      masks = np.zeros((64, 64), dtype=np.uint16)
      masks[8:24, 8:24] = 1
      masks[36:56, 30:50] = 2

      # Round trip masks -> flows -> masks without pretrained weights;
      # networks are trained on flows scaled by 5
      flows, _ = dynamics.masks_to_flows_gpu(masks)
      cellprob = np.where(masks > 0, 5.0, -5.0)
      result = dynamics.compute_masks(5 * flows, cellprob)

      ap = metrics.average_precision(masks, result)[0]
      assert np.allclose(ap, 1.0), ap
      print(len(np.unique(result)) - 1)
    PYTHON
    assert_equal "2", shell_output("#{libexec}/bin/python test.py").strip
  end
end

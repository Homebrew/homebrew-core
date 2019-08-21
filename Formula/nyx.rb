class Nyx < Formula
  desc "Command-line monitor for Tor"
  homepage "https://nyx.torproject.org/"
  url "https://files.pythonhosted.org/packages/f4/da/68419425cb0f64f996e2150045c7043c2bb61f77b5928c2156c26a21db88/nyx-2.1.0.tar.gz"
  sha256 "88521488d1c9052e457b9e66498a4acfaaa3adf3adc5a199892632f129a5390b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e45539c22cd0a63392fc06b83824094917c40f6bcbb2d3e05b95dfb2210f8556" => :mojave
    sha256 "e45539c22cd0a63392fc06b83824094917c40f6bcbb2d3e05b95dfb2210f8556" => :high_sierra
    sha256 "1becd20ec7f74fe0fb05655320ab0329562fdd119a8f29acfd3c80a3594d1564" => :sierra
  end

  depends_on "python"

  resource "stem" do
    url "https://files.pythonhosted.org/packages/7f/71/d82f4204e88be00220cc54eedb2972fd05081cb0e5ebdc537d8940b064ea/stem-1.7.1.tar.gz"
    sha256 "c9eaf3116cb60c15995cbd3dec3a5cbc50e9bb6e062c4d6d42201e566f498ca2"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resource("stem").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "Errno 61", shell_output("#{bin}/nyx -i 127.0.0.1:9000", 1)
  end
end

class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/79/71/10573e8d9e1f947e330bdd77724750163dbd80245840f7e852c9fec493c4/bpython-0.23.tar.gz"
  sha256 "9f0078abc887c48af088691e2f64797d6ca994ac0f4bc03c38d06f657d7c052a"
  license "MIT"
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7e1f934ecdfd7e176ae519a4f2e3c7842606ed91b4a7bbfe52ea1b053568d1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51415da492e0680a8f7506b7583987cc9e82a613b49ecaaa3f859858089e38b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09e671aeb6b897898d6a02c50b0cf23bc3e660f22bcb2db074f4bd29b9579783"
    sha256 cellar: :any_skip_relocation, ventura:        "e63b5bf3ca991828c469213bc38ff1821b6ea16fd4a9ce18657ce899fdfa7499"
    sha256 cellar: :any_skip_relocation, monterey:       "58eb4fcacb47a322c5dd459b1ffca04725bc5363093ca2d6cfd7916a89f65f68"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0cfb059ee562407de784c0cf94b1e11af2eb1326f936b49e79f15a1cd6af412"
    sha256 cellar: :any_skip_relocation, catalina:       "3beafb36bd3e94a97ba9d99538b59fdf9b9f344b70d9bb04421db9880c6a5867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ebf1532a49e4c88bbca4effe8dbc79b4a26e376bce4d2803d7445ca22d11a1"
  end

  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/e5/ad/97453480e7bdfce94f05a983cf7ad7f1d90239efee53d5af28e622f0367f/blessed-1.19.1.tar.gz"
    sha256 "9a0d099695bf621d4680dd6c73f6ad547f6a3442fbdbe80c4b1daa1edbc492fc"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/4e/43/838c06297741002403835436bba88c38d0a42ed9ce3e39a61de73e4cb4d0/curtsies-0.4.1.tar.gz"
    sha256 "62d10f349c553845306556a7f2663ce96b098d8c5bbc40daec7a6eedde1622b0"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/c6/6c/fe4a10bd3de2a3ecdcb53e8ad90ec9fddc846342e5e39e6446c692637414/cwcwidth-0.1.8.tar.gz"
    sha256 "5adc034b7c90e6a8586bd046bcbf6004e35e16b0d7e31de395513a50d729bbf6"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/d4/e7/e41e5150909f58d3161b7ab680d17bb8d47dbbc45385f07a870164d3d02f/greenlet-2.0.0.post0.tar.gz"
    sha256 "ad9abc3e4d2370cecb524421cc5c8a664006aa11d5c1cb3c9250e3bf65ab546e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    # Make the Homebrew site-packages available in the interpreter environment
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", HOMEBREW_PREFIX/site_packages
    ENV.prepend_path "PYTHONPATH", libexec/site_packages
    combined_pythonpath = ENV["PYTHONPATH"] + "${PYTHONPATH:+:}$PYTHONPATH"
    %w[bpdb bpython].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin/#{cmd}", PYTHONPATH: combined_pythonpath
    end
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4\n", shell_output("#{bin}/bpython test.py")
  end
end

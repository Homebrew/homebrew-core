class B2Tools < Formula
  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v0.6.2.tar.gz"
  sha256 "e897409da976ab7c1ecd9d99ed6987bdb55a4acf7c90609cb26f72420cf8ada7"

  bottle do
    cellar :any_skip_relocation
    sha256 "038f9ccdd7db52a971e01a76af0eb6f4d2aca06c47921fc3812b5254953cdc2b" => :el_capitan
    sha256 "b2af14494700c952cea63f5e88dfb00bd9be5c2129f20656e5ffb37fd2173ad0" => :yosemite
    sha256 "4d443066e20eacad9a7581da4de3243ec406635f978af7dd8d8409ef573fc375" => :mavericks
  end

  option "without-test", "Skip build-time tests"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "futures" do
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/ac/69/230201e59820455e4b3470c04c0153bb492bf7e885681c5c46635d273815/tqdm-4.7.6.tar.gz"
    sha256 "a0b615a402003bac24a065e88fb54832a974d7bc5412fe7b348e0d1fe80f00fd"
  end

  if build.with? "test"
    resource "funcsigs" do
      url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
      sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
    end

    resource "mock" do
      url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
      sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
    end

    resource "nose" do
      url "https://files.pythonhosted.org/packages/58/a5/0dc93c3ec33f4e281849523a5a913fa1eea9a3068acfa754d44d88107a44/nose-1.3.7.tar.gz"
      sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
    end

    resource "pbr" do
      url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
      sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
    end

    resource "pyflakes" do
      url "https://files.pythonhosted.org/packages/54/80/6a641f832eb6c6a8f7e151e7087aff7a7c04dd8b4aa6134817942cdda1b6/pyflakes-1.2.3.tar.gz"
      sha256 "2e4a1b636d8809d8f0a69f341acf15b2e401a3221ede11be439911d23ce2139e"
    end

    resource "setuptools" do
      url "https://files.pythonhosted.org/packages/84/24/610d8bb87219ed6d0928018b7b35ac6f6f6ef27a71ed6a2d0cfb68200f65/setuptools-24.0.3.tar.gz"
      sha256 "396b12411705a03a511fabe94fb0a2eb06671efc83f2cef46a7ee497a4314b67"
    end

    resource "yapf" do
      url "https://files.pythonhosted.org/packages/24/73/0f1a6991f3e8fd5c2af56b9eea260ae44ba2e6f3d418cc327b9e05409ecd/yapf-0.10.0.tar.gz"
      sha256 "aae542537fceb2a2f0b778758f0d48672d43046442ac3aec042c331519d34522"
    end
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[futures requests six tqdm].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    if build.with? "test"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"nosetests/lib/python2.7/site-packages"
      %w[setuptools funcsigs mock nose pbr pyflakes yapf].each do |r|
        resource(r).stage do
          system "python", *Language::Python.setup_install_args(buildpath/"nosetests")
        end
      end

      ENV.prepend_path "PATH", buildpath/"nosetests/bin"
      system "python", "setup.py", "nosetests" if build.with? "test"
    end

    bash_completion.install "contrib/bash_completion/b2" => "b2-tools-completion.bash"
  end

  test do
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "bad_auth_token", shell_output(cmd, 1)
  end
end

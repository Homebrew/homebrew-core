class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://docs.pipenv.org/"
  url "https://files.pythonhosted.org/packages/bf/e3/1615d03e17d1ad551a7dad967e5061f30c4ab29e53fe3ad5e8e88e297424/pipenv-11.10.0.tar.gz"
  sha256 "dab6b2e5347757cda7973e6c6065c30c020c5ff8b0687306b83e962aea4adc6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "79899f7c297073f5bac163b4150c2330506762a39e7cdf7cd7897fa6f7286304" => :high_sierra
    sha256 "642755deea9afef71e976b72994b36421fc17ceaf5d7a38bacd86aa3954f16c5" => :sierra
    sha256 "9ede5473425828810a13c80e987be968713b8c4a8d6e755e3eec3933b19ac84d" => :el_capitan
  end

  depends_on "python"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/15/d4/2f888fc463d516ff7bf2379a4e9a552fef7f22a94147655d9b1097108248/certifi-2018.1.18.tar.gz"
    sha256 "edbc3f203427eef571f79a7692bb160a2b0f7ccaa31953e99bd17e307cf63f7d"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/b1/72/2d70c5a1de409ceb3a27ff2ec007ecdd5cc52239e7c74990e32af57affe9/virtualenv-15.2.0.tar.gz"
    sha256 "1d7e241b431e7afce47e77f8843a276f652699d1fa4f93b9d8ce0076fd7b0b54"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/14/2f/84b6a8e380439cdfdb71e0ced2a805a66e343ac540d3304bde6bc28fbb46/virtualenv-clone-0.3.0.tar.gz"
    sha256 "b5cfe535d14dc68dfc1d1bb4ac1209ea28235b91156e2bba8e250d291c3fb4f8"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath

    # `pipenv` needs to be able to find `virtualenv` and `pewtwo` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pewtwo", libexec/"bin/pip",
                                      libexec/"bin/virtualenv"
    env = {
      :PATH => "#{libexec}/tools:$PATH",
    }
    (bin/"pipenv").write_env_script(libexec/"bin/pipenv", env)

    output = Utils.popen_read("#{libexec}/bin/pipenv --completion")
    (bash_completion/"pipenv").write output
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?
      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
    inreplace lib_python_path/"orig-prefix.txt",
              Formula["python"].opt_prefix, Formula["python"].prefix.realpath
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end

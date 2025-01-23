class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/2a/13/b62d075317d8686071eb843f0bb1f195eb332f48869d3c31a4c6f1e063ac/pre_commit-4.1.0.tar.gz"
  sha256 "ae3f018575a588e30dfddfab9a05448bfbd6b73d78709617b5a2b853549716d4"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec425622736978659e978cbc39251bb7750504622c0c1847e8f2e699a97d8608"
    sha256 cellar: :any,                 arm64_sonoma:  "5c6a82e6a2549a2969b6c287fb65ed7aa481c1a381ae84afd14ae25a84412433"
    sha256 cellar: :any,                 arm64_ventura: "37bf8dc10005b3c9d68ea55d937819ad87184f7a5531df7f0cdc023d6a55da25"
    sha256 cellar: :any,                 sonoma:        "b5a40f3551eeddc2bf4e1b7491784bcd6267684d8c238f891bfd8f8d4076f372"
    sha256 cellar: :any,                 ventura:       "c4fb09fbe85430f4e2df6e2f9d8a41c52218e6a7ceb30dfa6b0f84b6e6c3bb35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3908f181204927923aee99146af31bd73674588fbf1309f90afe62a24dbed699"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/cf/92/69934b9ef3c31ca2470980423fda3d00f0460ddefdf30a67adf7f17e2e00/identify-2.6.5.tar.gz"
    sha256 "c10b33f250e5bba374fae86fb57f3adcebf1161bce7cdf92031915fd480c13bc"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/43/16/fc88b08840de0e0a72a2f9d8c6bae36be573e475a6326ae854bcc549fc45/nodeenv-1.9.1.tar.gz"
    sha256 "6ec12890a2dab7946721edbfbcd91f3319c6ccc9aec47be7c7e6b7011ee6645f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a7/ca/f23dcb02e161a9bba141b1c08aa50e8da6ea25e6d780528f1d385a3efe25/virtualenv-20.29.1.tar.gz"
    sha256 "b8b8970138d32fb606192cb97f6cd4bb644fa486be9308fb9b63f81091b5dc35"
  end

  def python3
    "python3.13"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3}\")}\\n'"

    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.13"].opt_bin/python3
    python_opt = Formula["python@3.13"].opt_prefix
    python_cellar = python_opt.realpath
    dirs_to_fix = [libexec/"lib/python#{xy}"]
    dirs_to_fix << (libexec/"bin") if OS.linux?
    dirs_to_fix.each do |folder|
      folder.each_child do |f|
        next unless f.symlink?

        abspath = f.realpath.sub python_cellar, python_opt
        rm f
        ln_s abspath, f
      end
    end
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~YAML
      repos:
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          rev: v0.9.1
          hooks:
          -   id: trailing-whitespace
    YAML
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end

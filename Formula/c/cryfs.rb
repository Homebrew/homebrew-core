class Cryfs < Formula
  include Language::Python::Virtualenv

  desc "Encrypts your files so you can safely store them in Dropbox, iCloud, etc."
  homepage "https://www.cryfs.org"
  url "https://github.com/cryfs/cryfs/releases/download/0.11.4/cryfs-0.11.4.tar.gz"
  sha256 "6caca6276ce5aec40bf321fd0911b0af7bcffc44c3cb82ff5c5af944d6f75a45"
  license "LGPL-3.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9cec1f648aaa35adc5a9ede343188d831c60ccab0fb4eb67b5b744be65766d2e"
  end

  head do
    url "https://github.com/cryfs/cryfs.git", branch: "develop"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "curl"
  depends_on "fmt"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "python@3.12"
  depends_on "range-v3"
  depends_on "spdlog"

  fails_with gcc: "5"

  resource "versioneer" do
    url "https://files.pythonhosted.org/packages/32/d7/854e45d2b03e1a8ee2aa6429dd396d002ce71e5d88b77551b2fb249cb382/versioneer-0.29.tar.gz"
    sha256 "5ab283b9857211d61b53318b7c792cf68e798e765ee17c27ade9f6c924235731"
  end

  def install
    python = "python3.12"
    venv_root = buildpath/"venv"

    venv = virtualenv_create(venv_root, python)
    venv.pip_install resource("versioneer")

    ENV.prepend_path "PYTHONPATH", venv_root/Language::Python.site_packages(python)
    ENV.prepend_path "PATH", venv_root/"bin"

    configure_args = [
      "-DBUILD_TESTING=off",
    ]

    system "cmake", "-B", "build", "-S", ".", *configure_args, *std_cmake_args,
                    "-DCRYFS_UPDATE_CHECKS=OFF",
                    "-DDEPENDENCY_CONFIG=cmake-utils/DependenciesFromLocalSystem.cmake"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CRYFS_FRONTEND"] = "noninteractive"

    # Test showing help page
    assert_match "CryFS", shell_output("#{bin}/cryfs 2>&1", 10)

    # Test mounting a filesystem. This command will ultimately fail because homebrew tests
    # don't have the required permissions to mount fuse filesystems, but before that
    # it should display "Mounting filesystem". If that doesn't happen, there's something
    # wrong. For example there was an ABI incompatibility issue between the crypto++ version
    # the cryfs bottle was compiled with and the crypto++ library installed by homebrew to.
    mkdir "basedir"
    mkdir "mountdir"
    expected_output = "fuse: device not found, try 'modprobe fuse' first"
    assert_match expected_output, pipe_output("#{bin}/cryfs -f basedir mountdir 2>&1", "password")
  end
end

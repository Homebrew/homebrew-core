class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.29.2.tar.gz"
  sha256 "8aa740199868f80136164816d009cda4252a1d5a6e083744c4a78c44655b41e9"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a0f8a4ffd62e7efcb1b4117cb11ca703344383eaae4bcd518d79c9042a4bb8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dcc559de89a8e039c2e78cdf79838fd5b87695151f14c1092e3c5612dcf3ec2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f529621bafe68249c4f044c90ca96d76ad3c2f01cc5e014488a5081b463ee9f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cc326e2c58dc606d77c11779dd3a57e2db5741f4866ef10d82a9b08f66ca734"
    sha256 cellar: :any_skip_relocation, ventura:       "c99ebd6846066f948f40e868d79c102a837a1c3297e298be1a74d694c69644d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e603f0649cf9f9704616950a7ab3eb259eb4db77ebe644de0d8efaeb2625a4a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"moon", "init", "--minimal", "--yes"
    assert_predicate testpath/".moon"/"workspace.yml", :exist?
  end
end

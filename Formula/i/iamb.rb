class Iamb < Formula
  desc "Matrix client for Vim addicts"
  homepage "https://iamb.chat"
  url "https://github.com/ulyssa/iamb/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "a5cf4f248e0893b5657c5ad1234207c09968018c5462d4063c096f0db459dd7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60411f720f5ecb4b70440f08d92f30af8edea461235dece5d20f82b5d829d124"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a40984cdeff92b05714f11ae2977bcc2a3643f5766e3098f25bc948c70c1978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11d2bc8cefd59fe389d1c724c371d28a75cf5bd86548087ac7a00f294c7c7918"
    sha256 cellar: :any_skip_relocation, sonoma:        "b71100aaa5a4888f16b72cb16d0026cae7e9b90ac37ae55bc48fc7d0199102f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "419e544f93e47f8698e75c427defdb7757832096ba0cad731b5a9901462bc139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d98fe51949cb159dfab07e4b1269bb5dcd8825f59ebec0a80d1a8d509b47be2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite", since: :ventura # requires sqlite3_error_offset

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Please create a configuration file", shell_output(bin/"iamb", 2)
  end
end

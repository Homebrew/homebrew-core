class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.20.5.tar.gz"
  sha256 "3d99f2e129418800817e0e5a3ce4812c34537a32d50e37578189e90c79de7062"
  license "Apache-2.0"
  compatibility_version 6
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a1e59d4ce68758273299a6d1a4540e344578b18e5888b0624c2a5ce95d2a7326"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09c90bfdc94d21cc5b0a45629d1636e2d1e4ff54cb6e37efcb063dde38a1e317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e7b79340a0d6677f80cad16f65ffbc568f080c5bdeb779b6c95a3cb8c5b07f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6ab413b7451b217ad0a2fb6e0cd572a5510161e4150d973c3e1adb704542a26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ec0fb37681364337ec52533563a4f9d15aa765112d280af118e7a53e8fa813dd"
  end

  depends_on "erlang"

  deny_network_access!

  def install
    # Set `Q=` for verbose `make` output
    system "make", "Q=", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP \d+)}, shell_output("#{bin}/elixir -v"))
  end
end

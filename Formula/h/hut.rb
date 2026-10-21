class Hut < Formula
  desc "CLI tool for sr.ht"
  homepage "https://sr.ht/~xenrox/hut"
  url "https://git.sr.ht/~xenrox/hut/archive/v0.9.0.tar.gz"
  sha256 "1636cc4b8c983bb55dce25b074b24b9db989b47c2408c6835a6a4849c3ca9563"
  license "AGPL-3.0-or-later"
  head "https://git.sr.ht/~xenrox/hut", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d297d9701b3d05f8e92ec42d6bdf678ca49209117bbc8fffd630803bc3a443b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4f529f33e84d583e29dc836d49e41e43156906bd90072b251ff1d0fd47192755"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43d4ce48eb0eae6d821b60288574fbe67e47efd6276a3ac52fd1e04bc30e4837"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ef3357461a6e166ebaead83b5d73617bab88352e0a8fa6c7da8c09b05dd175a4"
    sha256 cellar: :any,                 x86_64_linux:      "ead0ed27f40ff314ea426f45ff202372bacd9f7bfed7cfc054247d7f21595344"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"config").write <<~EOS
      instance "sr.ht" {
          access-token "some_fake_access_token"
      }
    EOS
    assert_match "gqlclient: server failure: Invalid OAuth bearer token",
      shell_output("#{bin}/hut --config #{testpath}/config todo list 2>&1", 1)
  end
end

class Hut < Formula
  desc "CLI tool for sr.ht"
  homepage "https://sr.ht/~xenrox/hut"
  url "https://git.sr.ht/~xenrox/hut/archive/v0.8.0.tar.gz"
  sha256 "f7994375673f253705ed7499f44b712b2d9fcec8a5a42f1d0408002552b7d0e7"
  license "AGPL-3.0-or-later"
  head "https://git.sr.ht/~xenrox/hut", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eab8caeeb2d2b7188960ef3d62253898ef52c5e9946846b7221095a2b99c34b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46df5069ce266de5fde75f60a8b4e073500711efcf7e62a0cca95861bedaced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19b63774e2f23be87faef6211f173fce763d3593cfca7f5095f1534dec87a490"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f2af6b651a86312c2629539cf68fcf6f4defc66f86bf903dedabb7530bf550a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9e8310d8cd5ec4bb376aeb0d1df6325af8a34e21a66d41e87f7c557eb94f33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd0ed430648743fe454a209c37b2de392d242e27a4b171c07f80ac2a2c6662fa"
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

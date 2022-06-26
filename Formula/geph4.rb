class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.5.0.tar.gz"
  sha256 "8fa72c3630409d08b811654c288f32bb61dd2a8ae3c7ce101a0fb2d45e6df9d1"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "313da23eda7ff91eda76c3ae5bb864d115f79d1e1432948a668ba5f1ff25a567"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e12e443713c79bef926248ed1deb574da4cde4e0258ff2bb5468475620f0e97a"
    sha256 cellar: :any_skip_relocation, monterey:       "6b74c5f3239318d05a5d3955d7d3704abfdf2993f3eba73c5febd17d2eca564f"
    sha256 cellar: :any_skip_relocation, big_sur:        "558f1c34316108aa6bf44acda23486e108bb29199abec034999f99c910b2d769"
    sha256 cellar: :any_skip_relocation, catalina:       "699a00a14d77ba1f0ea220c720b5b1e1af8e2b88e8c7d99e3c336f4fbbfb14fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b976b33f8ae0fb4b0529ec138ec59d2f4a5ae5377b2178305c1e64f6c6bb8d96"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "{\"error\":\"wrong password\"}",
     shell_output("#{bin}/geph4-client sync --username 'test' --password 'test' --credential-cache ~/test.db")
       .lines.last.strip
  end
end

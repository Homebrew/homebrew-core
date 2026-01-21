class Doh < Formula
  desc "Stand-alone DNS-over-HTTPS resolver using libcurl"
  homepage "https://github.com/curl/doh"
  url "https://github.com/curl/doh/archive/refs/tags/doh-0.1.tar.gz"
  sha256 "b36c4b4a27fabb508d5d3bb0fb58bd9cfadcef30d22e552bbe5c4442ae81e742"
  license "MIT"
  head "https://github.com/curl/doh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9c8bb12c19ed1f9ee5a81150ab5238dc1521692b97ee7e2ac9f7b332c98de28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c39c61062f58d2554ce37add6e00e95dc8628fcd7a597699afb3f53d095e279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88e7c35829b8a8f2da88089b4ea6eecc482de447ac2db4664ad8c3bca1a66255"
    sha256 cellar: :any_skip_relocation, sonoma:        "17325afc86aa5389af5b957dcbd13155bff5ec0372e7c89fb5608f84deac154b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75b94ee73ea07d08efdc21cbc6ddd11298e438c7c41efcb7d35bdce181a8e7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0272e7f336538f7360c59c54889b19bb5d9f0cd723f44bc87e641bcd1f124de2"
  end

  uses_from_macos "curl"

  def install
    system "make"
    bin.install "doh"
    man1.install "doh.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doh -V")

    output = shell_output("#{bin}/doh google.com https://dns.google/dns-query")
    assert_match "google.com", output
  end
end

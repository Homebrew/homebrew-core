class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.9.4.tar.gz"
  sha256 "3356e1f795dddf067d69aff08cd3142763e8ead040c65d93994b6de3156f15a4"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7eb5cfa1d240e0e27991dba202b660ccf239dce632ef4a8df5ffeed9222f361e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6721af0e2d9859d5490924744909223af0d932b63e3389d9f45068884bf757f"
    sha256 cellar: :any_skip_relocation, monterey:       "b8831aff926507aa3416c2a9f489f0678182ac342d5cbbd1cc5dce5cce90886d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5622f39aec4eb485ff12212cee8d35ec11d9a3318a92429d2781a99cab0181eb"
    sha256 cellar: :any_skip_relocation, catalina:       "8726bbbe72be8c2e16b699f29b87d51d91a4e9a64b80a51bdf4c58421c79c1dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5657bf337a31e383a5591c032d8ffb844b9bd9923a124ec5accee41a11dd9b1b"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  plist_options startup: true

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/coredns.log"
    error_log_path var/"log/coredns.log"
  end

  test do
    port = free_port
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end

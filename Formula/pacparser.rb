class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/manugarg/pacparser"
  url "https://github.com/manugarg/pacparser/archive/v1.4.1.tar.gz"
  sha256 "97eb85832194bd4a98946fd92cebb9181fffb0763319086fc0541408b5d4415b"
  license "LGPL-3.0-or-later"
  head "https://github.com/manugarg/pacparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e4c3db484fe2bd33ae2c93d978c9367030a1d53446819f5fb2e17d11eba1bb69"
    sha256 cellar: :any,                 arm64_monterey: "9684968dc0488a7fefc960b48b07c730f51518c9302d1a28414b3b39079e570f"
    sha256 cellar: :any,                 arm64_big_sur:  "df9f100d605dbca0aa98b541e12821c0bfff9da126b2f6122122bd7cdf4b28a2"
    sha256 cellar: :any,                 ventura:        "40f638eb66c02c9fcbbf26dcbd0f3be7f2f63b79db9308ef82101715c3affc1c"
    sha256 cellar: :any,                 monterey:       "6e5c9c2959f9c21305bbaaa035422e0efffd87b7bac8345b4335759b3a850018"
    sha256 cellar: :any,                 big_sur:        "c75e37d499241a15b2fdfe6da3a9d2b25638f7225ec8df7479f7ebb08e2d08f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ae67f9bb8f2343863f7c4c3a0b2cbc776424d3e9595af9d000ad66bef3ba02b"
  end

  def install
    # Disable parallel build due to upstream concurrency issue.
    # https://github.com/manugarg/pacparser/issues/27
    ENV.deparallelize
    ENV["VERSION"] = version
    Dir.chdir "src"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # example pacfile taken from upstream sources
    (testpath/"test.pac").write <<~'EOS'
      function FindProxyForURL(url, host) {

        if ((isPlainHostName(host) ||
            dnsDomainIs(host, ".example.edu")) &&
            !localHostOrDomainIs(host, "www.example.edu"))
          return "plainhost/.example.edu";

        // Return externaldomain if host matches .*\.externaldomain\.example
        if (/.*\.externaldomain\.example/.test(host))
          return "externaldomain";

        // Test if DNS resolving is working as intended
        if (dnsDomainIs(host, ".google.com") &&
            isResolvable(host))
          return "isResolvable";

        // Test if DNS resolving is working as intended
        if (dnsDomainIs(host, ".notresolvabledomain.invalid") &&
            !isResolvable(host))
          return "isNotResolvable";

        if (/^https:\/\/.*$/.test(url))
          return "secureUrl";

        if (isInNet(myIpAddress(), '10.10.0.0', '255.255.0.0'))
          return '10.10.0.0';

        if ((typeof(myIpAddressEx) == "function") &&
            isInNetEx(myIpAddressEx(), '3ffe:8311:ffff/48'))
          return '3ffe:8311:ffff';

        else
          return "END-OF-SCRIPT";
      }
    EOS
    # Functional tests from upstream sources
    test_sets = [
      {
        "cmd" => "-c 3ffe:8311:ffff:1:0:0:0:0 -u http://www.example.com",
        "res" => "3ffe:8311:ffff",
      },
      {
        "cmd" => "-c 0.0.0.0 -u http://www.example.com",
        "res" => "END-OF-SCRIPT",
      },
      {
        "cmd" => "-u http://host1",
        "res" => "plainhost/.example.edu",
      },
      {
        "cmd" => "-u http://www1.example.edu",
        "res" => "plainhost/.example.edu",
      },
      {
        "cmd" => "-u http://manugarg.externaldomain.example",
        "res" => "externaldomain",
      },
      {
        "cmd" => "-u https://www.google.com",  ## internet
        "res" => "isResolvable",               ## required
      },
      {
        "cmd" => "-u https://www.notresolvabledomain.invalid",
        "res" => "isNotResolvable",
      },
      {
        "cmd" => "-u https://www.example.com",
        "res" => "secureUrl",
      },
      {
        "cmd" => "-c 10.10.100.112 -u http://www.example.com",
        "res" => "10.10.0.0",
      },
    ]
    # Loop and execute tests
    test_sets.each do |t|
      assert_equal t["res"],
        shell_output("#{bin}/pactester -p #{testpath}/test.pac " +
          t["cmd"]).strip
    end
  end
end

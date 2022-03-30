class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/pacparser/pacparser"
  url "https://github.com/pacparser/pacparser/archive/v1.3.9.tar.gz"
  sha256 "4eed48923f4430eca15e5483cf535c10d4442fdf353a9bb90a68e4e9ad6b1abb"
  license "LGPL-3.0-or-later"
  head "https://github.com/pacparser/pacparser.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_monterey: "30ceddf59723263d52009377de9a4003f962239dddd7f4033935e31b9efd90cc"
    sha256 cellar: :any,                 arm64_big_sur:  "1999482c32deaa8c6b9a38800b6dbc4f6d18076177f6a8a0dad49c21c4327781"
    sha256 cellar: :any,                 monterey:       "861d3e460101ce328b440dd01e53e1bb0ff7d17bb344ec11f6bac6d160733a05"
    sha256 cellar: :any,                 big_sur:        "55ce66921189d2ba41d3cf58f7548237442c5387372b8cc4bab891cf1ed7766f"
    sha256 cellar: :any,                 catalina:       "ca13d2507c9c6616bc6c3604c19a7f6f1652bb3b3c1fed3168c4d832a10b0174"
    sha256 cellar: :any,                 mojave:         "3544e7aed8d310d3407997f46b8b51cbbc2b1d962f90535175baff72301e375e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "171b897e20fc774db40f8d7e3a61e6367216cd485894f8b04c8a0d14a7bae9ed"
  end

  def install
    # Disable parallel build due to upstream concurrency issue.
    # https://github.com/pacparser/pacparser/issues/27
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

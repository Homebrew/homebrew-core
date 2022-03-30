class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/pacparser/pacparser"
  url "https://github.com/pacparser/pacparser/archive/v1.3.9.tar.gz"
  sha256 "4eed48923f4430eca15e5483cf535c10d4442fdf353a9bb90a68e4e9ad6b1abb"
  license "LGPL-3.0-or-later"
  head "https://github.com/pacparser/pacparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bca149211d2b46f6ca8e38e56721b89ec70eaeb3221391fff13b2003e1648e3e"
    sha256 cellar: :any,                 arm64_big_sur:  "f0a683baea4447d1d592372d8f0033be536a0e669dcbfe05a2f106fc3d0d5137"
    sha256 cellar: :any,                 monterey:       "c5e40234a2302eec8e4399dfeee3956d81782b1e98d95312e10439aa6d578f93"
    sha256 cellar: :any,                 big_sur:        "04c2df271cf3b1b590f9e07db969175a4d26e0811682c82afc0913bd94d64aaf"
    sha256 cellar: :any,                 catalina:       "bc0836bbe1ec53795234e0573f9c6b211fc35de3bd327f61fe5db2a3b2541185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52ee42a6f1031f07277f576020ef0bbcc568c989e09da76afc59aa99de3a9d51"
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

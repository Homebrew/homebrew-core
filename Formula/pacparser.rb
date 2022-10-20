class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/manugarg/pacparser"
  url "https://github.com/manugarg/pacparser/archive/v1.4.0.tar.gz"
  sha256 "d62d30aa6e2b4ccdf6773fc30a8b90d1d64eb6ad8edcbf56d2b803e913dcddbb"
  license "LGPL-3.0-or-later"
  head "https://github.com/manugarg/pacparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c9a4d912f32c3d95b1d3e9908c1bf173b5454ab2fe97b72d542e7e9d3323acaa"
    sha256 cellar: :any,                 arm64_big_sur:  "87c7b416faa3933313915c97df4908636f6fb90d076906aedb9ab0f6349b0184"
    sha256 cellar: :any,                 monterey:       "66567eed659b8c575fd086749fb206f091b4dac80c18aace817402f53363ce5d"
    sha256 cellar: :any,                 big_sur:        "ec53ab3e50bc58c1fb3226e83ea9dea4ccf12294674588a2ac05177699816b49"
    sha256 cellar: :any,                 catalina:       "99ad319b5cefd28b2d33f4645fa0f2f408a99b5905901eb61a052d38fa29df1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2afb1ac8ba357e7310b718a253d8d294ab9af92467a55c48110a73cc2284ea4"
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

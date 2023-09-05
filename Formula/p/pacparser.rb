class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/manugarg/pacparser"
  url "https://github.com/manugarg/pacparser/archive/v1.4.2.tar.gz"
  sha256 "99ddfdea3473fceef42a31dde59116ad79d04b2f1cd18d76556bbd50e2e80bbc"
  license "LGPL-3.0-or-later"
  head "https://github.com/manugarg/pacparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a31f761cf4a84788403a535adacf1069fe045b05d998560ea2136142917266de"
    sha256 cellar: :any,                 arm64_monterey: "a2a6e44959694d4ce4c83b1b7b3c9ed11a8dd28e8733c7c55c2f7c11e69569e5"
    sha256 cellar: :any,                 arm64_big_sur:  "1c4dadadb712f0238cfe4b585294f2fed4be69a8676ea8b7ac935c5efc5843e5"
    sha256 cellar: :any,                 ventura:        "7a222cb2fd5ba79eab74198f92fcddffe23824744d121175c735e025e9084c20"
    sha256 cellar: :any,                 monterey:       "231332325c62366976fa47ffbf5a20f05ca0261cb9bcbb88b1ed1f9ba136508e"
    sha256 cellar: :any,                 big_sur:        "73682a62f9366030e2b61c4b163d47115e903f193b14a591283f7c2fe7124cab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae4c6650a73027303e188b1a9904774cbff06d8a89ff0f65274d00f5f244211a"
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

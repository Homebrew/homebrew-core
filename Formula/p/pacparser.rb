class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/manugarg/pacparser"
  url "https://github.com/manugarg/pacparser/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "fac205f41d000e245519244dc3e730e649a0ac1c61b5f2d1d0660056e1680b2d"
  license "LGPL-3.0-or-later"
  head "https://github.com/manugarg/pacparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "270415ce44db451091e58c371dae0db097c42b98970153c67e55a7d63eef399d"
    sha256 cellar: :any,                 arm64_sonoma:   "22d47d663a8dee08bffab1c78bb4ed863317da5c9fa5bd8a937fe87784d8996e"
    sha256 cellar: :any,                 arm64_ventura:  "2eb88d3fbf6f69a38d7e9f95d8781d3471ad1b3cc89cfbfb7bbe4b08f9150a91"
    sha256 cellar: :any,                 arm64_monterey: "10f108fb57f52d0774b9f02981e5bdb2c0c569c9bd1b5fa789a7f8d4383d1e26"
    sha256 cellar: :any,                 sonoma:         "4d184243ed935d24e10744195addf345d21822ab299309636345ef1a8c5f14ae"
    sha256 cellar: :any,                 ventura:        "67d627d395f5c153f5025fe552c70931e6ab55f0dd2e7171414de5d43497e20d"
    sha256 cellar: :any,                 monterey:       "541bd6827519339d49f1521f5733fd9854961aec2fd48b157f70f99953e144a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "48d7f1676aa913adcc2892321ed98f34648bb6113d9085fa89186875271d7b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea64d408d99ac2dfd8426d17e8afd6e39ed561ab0b17b62baf9fe6d871e87982"
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

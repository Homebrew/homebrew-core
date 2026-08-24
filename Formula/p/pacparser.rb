class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/manugarg/pacparser"
  url "https://github.com/manugarg/pacparser/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "d744c3972f96e499dcf98fb853112e7b581fd53bb9bb4d9b7df738c2e7519cba"
  license "LGPL-3.0-or-later"
  head "https://github.com/manugarg/pacparser.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0dedb667324c98e705a42aa5549c3fb792f8eedd6266169ca123c2b2ec256326"
    sha256 cellar: :any, arm64_sequoia: "f5049f601598f92f754216c0e6abc0f31681cdceedfbbf2af1ebc0658cded65a"
    sha256 cellar: :any, arm64_sonoma:  "4fb077bb0c6f1412c3bd3056dcc94b215ee4b97bfa754c227a64b7ce157e98bd"
    sha256 cellar: :any, sonoma:        "22515a30e8f9381a7deafd0e5616de5124f716d3131c1cec84d37823d48662bb"
    sha256 cellar: :any, arm64_linux:   "c05adf8ba53a8eb4eaef1aabbea6a7d1b9268112bea40677f00531edd5f2ca2b"
    sha256 cellar: :any, x86_64_linux:  "1dc57e13e0ee31903d0e98b95a23414e09659b64279a8edfa0de59aa7694e28e"
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

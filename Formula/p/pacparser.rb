class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/manugarg/pacparser"
  url "https://github.com/manugarg/pacparser/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "2601a0e58e87caba6f4866aebefde2f5a44a277c05f01f17541ba8857c7a566e"
  license "LGPL-3.0-or-later"
  head "https://github.com/manugarg/pacparser.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39a44126df3d44f59c8715dc936e8ced528626c06b115990e3ec13e8ac56f8ca"
    sha256 cellar: :any,                 arm64_sequoia: "6a21090df23934b60f62ae3201e2dce07a3d474e475d0b4501e96b473acd3f8c"
    sha256 cellar: :any,                 arm64_sonoma:  "3f4b9365bf22505f77fd1e15fbf5f3679c6cda66e5bb0d1f36939857a798c2ce"
    sha256 cellar: :any,                 sonoma:        "063baea8c6d415189ab1f448afb5ec5cbf67d5edf17fb0cd488617ced915ca66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f7df8ad84a4fcf3f60884dee60d65897b724b82f6a6c347abbb1bd0997dba1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52fe3751f79b2bfcbd8019ddfd9d9b2050854bd779e9ebbcb2b367c83e1b31a7"
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

class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/manugarg/pacparser"
  url "https://github.com/manugarg/pacparser/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "437adddb23fac102a4fb781f49ef4da41cf62d12a24920061b8eaccc98c528af"
  license "LGPL-3.0-or-later"
  head "https://github.com/manugarg/pacparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "44fffec03bfd001b9350fdcf15960961b0c30b5d36c282b50503a466064d687b"
    sha256 cellar: :any,                 arm64_ventura:  "78cf14483acf7c7e46e523364782bd00dfa8ca4abb14a2d65db9162a5c3ba48a"
    sha256 cellar: :any,                 arm64_monterey: "66308f2c2adef547c1ab4ec8c97b0a550ab5721a3308b4d829b35fa998ed7b1b"
    sha256 cellar: :any,                 sonoma:         "bcb38cce78607101dd674b59e515b3fb4fd2e09774cea9fb889ada0424b7aea3"
    sha256 cellar: :any,                 ventura:        "337edff454a7841691fd49db5ca73d1d4e955ece6791544de6c8b9f6faace96c"
    sha256 cellar: :any,                 monterey:       "9bb74f68cd177f97f9359bbf8a11fe7c6c9f1827b010da3cd9648fcb8cbe6ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd68b68880db12acd79f3c6d212b63d3969ad0efc4d0a7e670e5c483ffca1539"
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

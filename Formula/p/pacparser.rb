class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/manugarg/pacparser"
  url "https://github.com/manugarg/pacparser/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "15cf308ddab9e9c19c59db355189dbfa008eac636ac651b0f9ff673b2edcadc5"
  license "LGPL-3.0-or-later"
  head "https://github.com/manugarg/pacparser.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f71f4a257a886be7da0a3919b66ab59ab6a9e3c62603cb43120b6781110989df"
    sha256 cellar: :any, arm64_tahoe:       "13f355c8bf2e9e4b84b08b93d6e72f0b6165bba1249fc593a14c960611a295ef"
    sha256 cellar: :any, arm64_sequoia:     "94c8383c09a4f49b081dee75b26e61cb0a4e67bb1e99c63cf050d9197c1f44ac"
    sha256 cellar: :any, arm64_linux:       "51352cd2b2e2261613846961b1b3209ca229df09c376cdc34d9b24b155589ecb"
    sha256 cellar: :any, x86_64_linux:      "20fd90bba14b1437fb5748c51ea1517a7aacd5be9e221957137846ee398c24be"
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

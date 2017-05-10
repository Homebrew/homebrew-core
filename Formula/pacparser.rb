class Pacparser < Formula
  desc "Library to parse proxy auto-config (PAC) files"
  homepage "https://github.com/pacparser/pacparser"
  url "https://github.com/pacparser/pacparser/archive/1.3.7.tar.gz"
  sha256 "575c5d8096b4c842b2af852bbb8bcfde96170b28b49f33249dbe2057a8beea13"
  head "https://github.com/pacparser/pacparser.git"

  bottle do
    cellar :any
    sha256 "38db6b19b4cec0c237b6c9e11b67db9514b58e12e5dad0edc97e9919e57f71b3" => :sierra
    sha256 "7cd235305c7701181eb78c7b35683e88bb9fb14172f4c1ff7028b3fd5b480cf9" => :el_capitan
    sha256 "3d2092ad71629a2c71d5b88138d0ea7443247d7cd89414ef46a9cab7898b250c" => :yosemite
  end

  depends_on "python" => :optional

  def install
    # Disable parallel build due to upstream concurrency issue.
    # https://github.com/pacparser/pacparser/issues/27
    ENV.deparallelize
    ENV["VERSION"] = version
    Dir.chdir "src"
    system "make", "install",
           "PREFIX=#{prefix}"
    if build.with? "python"
      system "make", "install-pymod",
             "EXTRA_ARGS=\"--prefix=#{prefix}\""
    end
  end

  test do
    # example pacfile taken from upstream sources
    (testpath/"test.pac").write <<-'EOS'.undent
      function FindProxyForURL(url, host) {

        if ((isPlainHostName(host) ||
            dnsDomainIs(host, ".manugarg.com")) &&
            !localHostOrDomainIs(host, "www.manugarg.com"))
          return "plainhost/.manugarg.com";

        // Return externaldomain if host matches .*\.externaldomain\.com
        if (/.*\.externaldomain\.com/.test(host))
          return "externaldomain";

        // Test if DNS resolving is working as intended
        if (dnsDomainIs(host, ".google.com") &&
            isResolvable(host))
          return "isResolvable";

        // Test if DNS resolving is working as intended
        if (dnsDomainIs(host, ".notresolvabledomainXXX.com") &&
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
        "cmd" => "-c 3ffe:8311:ffff:1:0:0:0:0 -u http://www.example.com/",
        "res" => "3ffe:8311:ffff",
      },
      {
        "cmd" => "-c 0.0.0.0 -u http://www.google.co.in/",
        "res" => "END-OF-SCRIPT",
      },
      {
        "cmd" => "-u https://host1",
        "res" => "plainhost/.manugarg.com",
      },
      {
        "cmd" => "-u https://www1.manugarg.com",
        "res" => "plainhost/.manugarg.com",
      },
      {
        "cmd" => "-u https://manugarg.externaldomain.com/",
        "res" => "externaldomain",
      },
      {
        "cmd" => "-u https://www.google.com/",  ## internet
        "res" => "isResolvable",                ## required
      },
      {
        "cmd" => "-u https://www.notresolvabledomainXXX.com/",
        "res" => "isNotResolvable",
      },
      {
        "cmd" => "-u https://www.example.com/",
        "res" => "secureUrl",
      },
      {
        "cmd" => "-c 10.10.100.112 -u http://www.example.com/",
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

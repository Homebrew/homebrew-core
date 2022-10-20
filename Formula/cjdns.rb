class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v21.2.tar.gz"
  sha256 "dec6ba261b423ea08e3a62a146ffd5db2b49a0b954a37fc37b24b35da2f7f773"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://github.com/cjdelisle/cjdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c48aa4df04535caab99cd5c645f4ba339a88d9c3bccecb5a63632fa74f75cf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6eabaa1782af8d391877acc7c9448791458d05e78c78d7efe17a171153273a2f"
    sha256 cellar: :any_skip_relocation, monterey:       "e6acfc82d7cd2878c581eea1e8b4b0b3b1ca6244a7ed8332fc94b8c63c9640bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "50872d7ab683ad6bcb899d3746793b3792c0a609736b8f1a3f9badaa9ab2b17b"
    sha256 cellar: :any_skip_relocation, catalina:       "df4aff8124a740742b35a22b66fc4e266110ffe6987089e08ac453783a80f43e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b20f0604ee2f09127ee8546a90fbed715123c19acc214d2fab06d88ef157985c"
  end

  depends_on "node" => :build
  # Fails to build with python@3.10.
  # AttributeError: module 'collections' has no attribute 'MutableSet'
  # Related PR: https://github.com/cjdelisle/cjdns/pull/1246
  depends_on "python@3.9" => :build
  depends_on "rust" => :build

  def install
    # Libuv build fails on macOS with: env: python: No such file or directory
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin" if OS.mac?

    # Avoid using -march=native
    inreplace "node_build/make.js",
              "var NO_MARCH_FLAG = ['arm', 'ppc', 'ppc64'];",
              "var NO_MARCH_FLAG = ['x64', 'arm', 'arm64', 'ppc', 'ppc64'];"

    system "./do"
    bins = %w[cjdroute makekeys privatetopublic publictoip6 randombytes sybilsim]
    bin.install(*bins)

    # Avoid conflict with mkpasswd from `expect`
    bin.install "mkpasswd" => "cjdmkpasswd"

    man1.install "doc/man/cjdroute.1"
    man5.install "doc/man/cjdroute.conf.5"
  end

  test do
    sample_conf = JSON.parse(shell_output("#{bin}/cjdroute --genconf"))
    sample_private_key = sample_conf["privateKey"]
    sample_public_key = sample_conf["publicKey"]
    sample_ipv6 = IPAddr.new(sample_conf["ipv6"]).to_s

    expected_output = <<~EOS
      Input privkey: #{sample_private_key}
      Matching pubkey: #{sample_public_key}
      Resulting address: #{sample_ipv6}
    EOS

    assert_equal expected_output, pipe_output(bin/"privatetopublic", sample_private_key)
  end
end

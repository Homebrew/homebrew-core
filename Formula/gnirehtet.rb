class Gnirehtet < Formula
  desc "Reverse tethering tool for Android"
  homepage "https://github.com/Genymobile/gnirehtet"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Genymobile/gnirehtet.git", branch: "master"

  stable do
    url "https://github.com/Genymobile/gnirehtet/archive/v2.5.tar.gz"
    sha256 "2b55b56e1b21d1b609a0899fe85d1f311120bb12b04761ec586187338daf6ec5"

    # Fix compilation issue with rust 1.64.0+
    # upstream PR reference, https://github.com/Genymobile/gnirehtet/pull/478
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/d62149f/gnirehtet/2.5-rust-1.64.0.patch"
      sha256 "bdda0abc50344b14227d880d8257189f49eb586722b6e5fa07f3cb70b442b7a0"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f898c125e921c9964c5e99e15d71c161acf11303f0aeacc3cf02688a8fe3dc45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b749da90ce130575ede02eb8b67bf16da7cc7c8f3abbecbf8538d5bb3671bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e513959ed8e72cae40ebbb1b83dd0b7d5637f9ff0010ce56382a26eed0a0538d"
    sha256 cellar: :any_skip_relocation, ventura:        "d4edb6c22347cf1c9040d246b43af1a614824c699e75fbe30865c8e0dd1b3b28"
    sha256 cellar: :any_skip_relocation, monterey:       "4b006bbe28c843a99b4bb11f20bbcbdc05e4186b2578bc8f01afbddf750469e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad3bcc48b5baf59b30a8a2afc4d649faa24fb2089bfb43eb5c8ea9da44b203d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f8f3ad93ec32d18934e9af5a0c81b872f5b9a9c8388a3b6aec065c1dec81bd"
  end

  depends_on "rust" => :build
  depends_on "socat" => :test

  resource "java_bundle" do
    url "https://github.com/Genymobile/gnirehtet/releases/download/v2.5/gnirehtet-java-v2.5.zip"
    sha256 "c65fc1a35e6b169ab6aa45e695c043e933f6fd650363aea7c2add0ecb0db27ca"
  end

  def install
    resource("java_bundle").stage { libexec.install "gnirehtet.apk" }

    system "cargo", "install", *std_cargo_args(root: libexec, path: "relay-rust")
    mv "#{libexec}/bin/gnirehtet", "#{libexec}/gnirehtet"

    (bin/"gnirehtet").write_env_script("#{libexec}/gnirehtet", GNIREHTET_APK: "#{libexec}/gnirehtet.apk")
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    gnirehtet_err = testpath/"gnirehtet.err"
    gnirehtet_out = testpath/"gnirehtet.out"

    port = free_port
    begin
      child_pid = fork do
        Process.setsid
        $stdout.reopen(gnirehtet_out, "w")
        $stderr.reopen(gnirehtet_err, "w")
        exec bin/"gnirehtet", "relay", "-p", port.to_s
      end
      sleep 3
      system "socat", "-T", "1", "-", "TCP4:127.0.0.1:#{port}"
    ensure
      pgid = Process.getpgid(child_pid)
      Process.kill("HUP", -pgid)
      Process.detach(pgid)
    end

    assert_empty File.readlines(gnirehtet_err)

    output = File.readlines(gnirehtet_out)
    assert output.any? { |l| l["TunnelServer: Client #0 connected"] }
    assert output.any? { |l| l["TunnelServer: Client #0 disconnected"] }
  end
end

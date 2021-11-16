class HarmonyOne < Formula
  desc "Harmony Blockchain Node"
  homepage "https://github.com/harmony-one/harmony"
  # CONTRIBUTORS: Update the following (url, sha256)
  url "https://github.com/harmony-one/harmony/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "d463cd60973509f2a7e906582a09a7cd21cf3638b956f164c63e0536a2063367"
  license "LGPL-3.0-or-later"

  # CONTRIBUTORS: Versions may need to be updated according to documentation at:
  #    -  https://github.com/harmony-one/harmony
  depends_on arch: :intel
  depends_on "gmp"
  depends_on "go"
  depends_on "jq"
  depends_on "openssl@3"

  on_linux do
    depends_on "gcc"
  end

  # CONTRIBUTORS: Keep resources updated according to the changelog release tag:
  #     - https://github.com/harmony-one/harmony/releases/tag/v#{version}
  resource "bls" do
    url "https://github.com/harmony-one/bls.git",
        revision: "2b7e49894c0f15f5c40cf74046505b7f74946e52"
  end

  resource "mcl" do
    url "https://github.com/harmony-one/mcl.git",
        revision: "99e9aa76e84415e753956c618cbc662b2f373df1"
  end

  def install
    # See https://github.com/golang/go/issues/26487
    ENV.O0 if OS.linux?

    # Setup Build Paths
    ENV["GOPATH"] = buildpath

    harmony_path = buildpath/"src/github.com/harmony-one/harmony"
    harmony_path.install buildpath.children

    %w[mcl bls].each do |r|
      temp_dir = buildpath/"src/github.com/harmony-one/#{r}"

      resource(r).stage do
        mv pwd, temp_dir
      end
    end

    cd buildpath/"src/github.com/harmony-one/harmony"

    # Build Binarys
    system "make"

    bin.install "./bin/harmony" => "harmony"
    bin.install "./bin/bootnode" => "bootnode"
    lib.install Dir["./bin/*.{dylib,so}"]
  end

  def caveats
    <<~EOS
      # Harmony-One Blockchain Node
      "Run a Harmony One blockchain Node"

      NOTICE: Due to Macos Security you may need to allow
      the application under Settings > Security & Privacy > General
      You may also need to allow network access depending on your firewall
      configuration.


      Find more documentation at:

      https://github.com/harmony-one/harmony
      https://docs.harmony.one/home/network/wallets/harmony-cli/download-setup#1-for-linux-pure-statically-linked-binary
      https://docs.harmony.one/home/network/wallets/harmony-cli/create-import-wallet

    EOS
  end

  test do
    # Basic version check
    assert_match version.to_s,  shell_output("bootnode --version")
    assert_match version.to_s,  shell_output("harmony --version")

    # Test that the binary fails with bls key error
    assert_match(/ERROR(.*)(bls.*)/, shell_output("harmony"))
  end
end

class OvhTtyrec < Formula
  desc "Enhanced (but compatible) version of the classic ttyrec"
  homepage "https://github.com/ovh/ovh-ttyrec"
  url "https://github.com/ovh/ovh-ttyrec/archive/refs/tags/v1.2.0.1.tar.gz"
  sha256 "d6b841c8d01f8d8a744f585ac765f2837054ed0a190cc0985d81e74972becc3a"
  license all_of: ["BSD-3-Clause", "BSD-4-Clause-UC"]
  compatibility_version 1

  bottle do
    manifest_sha256 "b857a9879cd937e09c10d44d488cfba213524f254922ee142b64efbc3546fb4c"
    sha256 cellar: :any, arm64_golden_gate: "49c76ef839781713412995467ac6eb9b13cb53a921572c2e23141022e1c54da3"
    sha256 cellar: :any, arm64_tahoe:       "eef33b07caa38cf80d5c3e9d985697b1d8308e8c42b6717721cdb013f3ba36e7"
    sha256 cellar: :any, arm64_sequoia:     "a9cd3deebf729a009eb87270b33e6f634bddb5116ab2e444a54ea8dedd70ea46"
    sha256 cellar: :any, arm64_linux:       "2c4804ba637ed8cc4580503d0a681cd06dc8c5e1ce432d9675b294ff8f533a86"
    sha256 cellar: :any, x86_64_linux:      "daf275236fc6323c4596d54a5d8724392ba6fb38f96c1cb1069541d9923b24fd"
  end

  depends_on "zstd"

  conflicts_with "ttyrec", because: "both install the same binaries"

  deny_network_access!

  def install
    ENV["NO_STATIC_ZSTD"] = "1"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.tty").binwrite([0, 0, 4].pack("V3") + "test" + [9, 0, 3].pack("V3") + "end")

    assert_equal "9\ttest.tty", shell_output("#{bin}/ttytime test.tty").strip
  end
end

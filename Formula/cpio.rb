class Cpio < Formula
  desc "Copies files into or out of a cpio or tar archive"
  homepage "https://www.gnu.org/software/cpio/"
  url "https://ftp.gnu.org/gnu/cpio/cpio-2.13.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cpio/cpio-2.13.tar.bz2"
  sha256 "eab5bdc5ae1df285c59f2a4f140a98fc33678a0bf61bdba67d9436ae26b46f6d"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86744e53b4827c9247d7e4bb5a35c6bb1a018da2a060fae5d1bb3691ea2fd13a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88bef9fc6dd8b882e98bf245b7a9cca1a44155d7987725a547bd63877fa216da"
    sha256 cellar: :any_skip_relocation, monterey:       "10f927b46fc83ef07e40f32e82a9a9588e9a442a74d6651d252bd5363c8c4446"
    sha256 cellar: :any_skip_relocation, big_sur:        "5536f0e39997060791f3b7defe996e48e163068342a32340903783a74220347b"
    sha256 cellar: :any_skip_relocation, catalina:       "1e2e8f240d9455593a653d4cc0759ee1a0596fe88641ad6a79d652f6596bb21b"
    sha256 cellar: :any_skip_relocation, mojave:         "566b73ec056c1441e84e5be4d8f22ae0e9eec609e340d56d9ba22ebefaa273c6"
    sha256 cellar: :any_skip_relocation, high_sierra:    "35cc00b8c97558822cc49cca1f40ba7a3a65af06be17317721ff471414c6f430"
    sha256                               x86_64_linux:   "cc0acbb967d8ec3b91bda22a59afa341569d0b4e6635cd0e4050e364a6bc2524"
  end

  keg_only :shadowed_by_macos, "macOS provides cpio"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    return if OS.mac?

    # Delete rmt, which causes conflict with `gnu-tar`
    (libexec/"rmt").unlink
    (man8/"rmt.8").unlink
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <string>
    EOS
    system "ls #{testpath} | #{bin}/cpio -ov > #{testpath}/directory.cpio"
    assert_path_exists "#{testpath}/directory.cpio"
  end
end

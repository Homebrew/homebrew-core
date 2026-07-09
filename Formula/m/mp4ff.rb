class Mp4ff < Formula
  desc "Tools for parsing and manipulating MP4/ISOBMFF files"
  homepage "https://github.com/Eyevinn/mp4ff"
  url "https://github.com/Eyevinn/mp4ff/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "b6ec3f2267f4cd201c8c68ce8ce865ca2535a84bc37440dcec0b65e8fd92b648"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a55162c6fbe4aeccc77c7225910c7f590a81338ec3ca2ac4a8750cbdbc816e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a55162c6fbe4aeccc77c7225910c7f590a81338ec3ca2ac4a8750cbdbc816e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a55162c6fbe4aeccc77c7225910c7f590a81338ec3ca2ac4a8750cbdbc816e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cdaaecc23b64e0993e0fdaa88391cc9496e63b54af17b47342cea79a5aa0aae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a30ab0420700a50c60b22d5724dee80518af8bd7262b934d0c3a27aa33e2241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef60292a003179c12891dd37a275939c4d1583c9751eb7b684533b71f9ef02fc"
  end

  depends_on "go" => :build

  def tools
    %w[mp4ff-crop mp4ff-decrypt mp4ff-encrypt mp4ff-info mp4ff-nallister mp4ff-pslister mp4ff-subslister]
  end

  def install
    tools.each do |tool|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/tool), "./cmd/#{tool}"
    end
  end

  test do
    resource "homebrew-init" do
      url "https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.52.0/mp4/testdata/init.mp4"
      sha256 "09a99ab8be9a39c80dc41ac6d4c9539b16947aab95abbadec903bfcb7a322221"
    end

    resource "homebrew-segment" do
      url "https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.52.0/mp4/testdata/1.m4s"
      sha256 "00dd5f29bc6ba64a9d8540cdbeda7a3e5be0f0ed67475ab307506d7462fc2d98"
    end

    resource "homebrew-prog" do
      url "https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.52.0/mp4/testdata/prog_8s.mp4"
      sha256 "86651d2aa80c714440fee3499ac3dd258b75043c4ceb455d70babb7873b16feb"
    end

    resource "homebrew-subs" do
      url "https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.52.0/cmd/mp4ff-subslister/testdata/multi_vttc.mp4"
      sha256 "1518ba79c86f28414f9285910f8118e00d3b70aa07c6a48ebb1f80b476b1192a"
    end

    # Build a combined fragmented MP4 from init segment + media segment
    resource("homebrew-init").stage(testpath/"init")
    resource("homebrew-segment").stage(testpath/"seg")
    (testpath/"test.mp4").binwrite(
      (testpath/"init/init.mp4").binread + (testpath/"seg/1.m4s").binread,
    )

    # mp4ff-info: fragmented H.264 file structure
    output = shell_output("#{bin}/mp4ff-info #{testpath}/test.mp4")
    assert_match "[ftyp]", output
    assert_match "[moof]", output
    assert_match "[avc1]", output

    # mp4ff-nallister: list NAL units
    output = shell_output("#{bin}/mp4ff-nallister #{testpath}/test.mp4")
    assert_match "IDR_5", output

    # mp4ff-pslister: extract parameter sets
    output = shell_output("#{bin}/mp4ff-pslister -i #{testpath}/test.mp4 -c avc")
    assert_match "avc1.64001E", output

    # mp4ff-encrypt + mp4ff-decrypt round-trip
    key = "00112233445566778899aabbccddeeff"
    system bin/"mp4ff-encrypt", "-key", key, "-iv", "00000000000000000000000000000000",
           "-kid", key, "-scheme", "cenc", testpath/"test.mp4", testpath/"enc.mp4"
    output = shell_output("#{bin}/mp4ff-info #{testpath}/enc.mp4")
    assert_match "[encv]", output
    assert_match "[sinf]", output

    system bin/"mp4ff-decrypt", "-key", key, testpath/"enc.mp4", testpath/"dec.mp4"

    # mp4ff-crop: progressive H.264
    testpath.install resource("homebrew-prog")
    input_info = shell_output("#{bin}/mp4ff-info #{testpath}/prog_8s.mp4")
    assert_match "[stsz] size=980", input_info
    output = shell_output("#{bin}/mp4ff-crop -d 2000 #{testpath}/prog_8s.mp4 #{testpath}/cropped.mp4")
    assert_match "endTime=2000ms", output
    cropped_info = shell_output("#{bin}/mp4ff-info #{testpath}/cropped.mp4")
    assert_match "[stsz] size=260", cropped_info

    # mp4ff-subslister: fragmented WebVTT subtitle segment
    testpath.install resource("homebrew-subs")
    output = shell_output("#{bin}/mp4ff-subslister #{testpath}/multi_vttc.mp4")
    assert_match '- cueText: "<c.white.bg_black>Ouais ! Belle gosse ! Voici 2 M !</c>"', output

    # Version check for all tools
    tools.each do |tool|
      assert_match "#{tool} v#{version}", shell_output("#{bin}/#{tool} -version")
    end
  end
end

class Mp4ff < Formula
  desc "Tools for parsing and manipulating MP4/ISOBMFF files"
  homepage "https://github.com/Eyevinn/mp4ff"
  url "https://github.com/Eyevinn/mp4ff/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "8318a6045e26bb9e901442773aac2a8827bfda3f9d77e72468ca0f1ea8ac1efe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c76ba8cea71d782d2bfd8375e2f20734651119a620e9eeade236cc8390af8b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c76ba8cea71d782d2bfd8375e2f20734651119a620e9eeade236cc8390af8b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c76ba8cea71d782d2bfd8375e2f20734651119a620e9eeade236cc8390af8b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f926ff500204c557c7b1b22c8d3e032cd92c8cd68727f5959099b5c778f1623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5f53ae01df2e2db4cc4a40cf5e57d15a42e11bf8921558a8079b3803a8c525a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25ed72e39527fda6b411ce43426b4955ece85ed4cefd8f8cbb4541e8d8b9c701"
  end

  depends_on "go" => :build

  def tools
    %w[mp4ff-crop mp4ff-decrypt mp4ff-encrypt mp4ff-info mp4ff-nallister mp4ff-pslister mp4ff-subslister]
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/Eyevinn/mp4ff/internal.commitVersion=v#{version}
      -X github.com/Eyevinn/mp4ff/internal.commitDate=#{time.iso8601}
    ]

    tools.each do |tool|
      system "go", "build", *std_go_args(ldflags:, output: bin/tool), "./cmd/#{tool}"
    end
  end

  test do
    resource "homebrew-init" do
      url "https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.51.0/mp4/testdata/init.mp4"
      sha256 "09a99ab8be9a39c80dc41ac6d4c9539b16947aab95abbadec903bfcb7a322221"
    end

    resource "homebrew-segment" do
      url "https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.51.0/mp4/testdata/1.m4s"
      sha256 "00dd5f29bc6ba64a9d8540cdbeda7a3e5be0f0ed67475ab307506d7462fc2d98"
    end

    resource "homebrew-prog" do
      url "https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.51.0/mp4/testdata/prog_8s.mp4"
      sha256 "86651d2aa80c714440fee3499ac3dd258b75043c4ceb455d70babb7873b16feb"
    end

    resource "homebrew-subs" do
      url "https://raw.githubusercontent.com/Eyevinn/mp4ff/v0.51.0/cmd/mp4ff-subslister/testdata/multi_vttc.mp4"
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

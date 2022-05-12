class Kromium < Formula
  desc "Bulk file copy/transformation tool"
  homepage "https://kromium.io"
  url "https://github.com/sharvanath/kromium/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "5634282e989923b0f6960102d63f7e8fb6d91010ac36c6d4cf1fa8bc1e158eb5"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kromium -version")
    %w[src dst state].map { |d| (testpath/d).mkpath }
    system "echo hello > src/file1"
    assert_match "file1", shell_output("ls src")
    assert_match "", shell_output("ls dst")
    system "echo { > test.cue"
    system "echo \"SourceBucket: \\\"file://`pwd`/src\\\"\" >> test.cue"
    system "echo \"DestinationBucket: \\\"file://`pwd`/dst\\\"\" >> test.cue"
    system "echo \"StateBucket: \\\"file://`pwd`/state\\\"\" >> test.cue"
    system "echo 'Transforms: [{ Type: \"Identity\" }]' >> test.cue"
    system "echo } >> test.cue"
    system "#{bin}/kromium", "-run", "test.cue", "-render=false"
    assert_match "file1", shell_output("ls dst")
  end
end

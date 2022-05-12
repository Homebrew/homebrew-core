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
    (testpath/"src/file1").write "hello\n"
    (testpath/"test.cue").write <<~EOS
      {
      SourceBucket: "file://#{testpath}/src"
      DestinationBucket: "file://#{testpath}/dst"
      StateBucket: "file://#{testpath}/state"
      Transforms: [{ Type: "Identity" }]
      }
    EOS
    system "#{bin}/kromium", "-run", "test.cue", "-render=false"
    assert_predicate testpath/"dst/file1", :exist?
  end
end

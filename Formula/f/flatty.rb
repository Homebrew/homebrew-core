class Flatty < Formula
  desc "Directory flattening tool that combines files into a single text document"
  homepage "https://github.com/mattmireles/flatty"
  url "https://raw.githubusercontent.com/mattmireles/flatty/main/flatty.sh"
  version "0.1.0"
  sha256 "0e1eaa123f7f0cc2ed9bc3e192574197d1b164fd181f5d966572613a68cc3d29" # Will guide you on getting this
  license "MIT"

  def install
    bin.install "flatty.sh" => "flatty"
  end

  test do
    # Create a test directory structure
    (testpath/"test_dir").mkpath
    (testpath/"test_dir/test.txt").write("test content")

    # Create the output directory where the script expects it
    ENV["HOME"] = testpath
    (testpath/"flattened").mkpath

    # Run flatty from within the test directory
    cd testpath/"test_dir" do
      system bin/"flatty"
    end

    assert_predicate testpath/"flattened", :exist?
  end
end

class PklGenSwift < Formula
  desc "Generate Swift source code for Pkl schemas"
  homepage "https://pkl-lang.org/swift/current/index.html"
  url "https://github.com/apple/pkl-swift/archive/refs/tags/0.2.3.tar.gz"
  sha256 "2318ab9f641237a70531652b78fcdcf2e9cb609f96e5386778dd08e14fe847b4"
  license "Apache-2.0"
  head "https://github.com/apple/pkl-swift.git", branch: "main"

  depends_on xcode: ["15.0", :build]
  depends_on "pkl"

  uses_from_macos "swift" => :build

  def install
    args = [
      "build",
      "--disable-sandbox",
      "--configuration",
      "release",
      "--product",
      "pkl-gen-swift",
    ]
    system "swift", *args
    bin_path = Utils.safe_popen_read("swift", *args, "--show-bin-path").chomp
    bin.install "#{bin_path}/pkl-gen-swift"
  end

  test do
    (testpath/"bird.pkl").write <<~PKL
      name = "Swallow"
      job {
        title = "Sr. Nest Maker"
        company = "Nests R Us"
        yearsOfExperience = 2
      }
    PKL
    system bin/"pkl-gen-swift", "bird.pkl", "-o", testpath
    assert_predicate testpath/"bird.pkl.swift", :exist?
  end
end

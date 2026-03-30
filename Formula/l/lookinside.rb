class Lookinside < Formula
  desc "Inspect debuggable app targets from the command-line"
  homepage "https://github.com/Lakr233/LookInside"
  url "https://github.com/Lakr233/LookInside/archive/refs/tags/2.2.2.tar.gz"
  sha256 "4b274672ae95da201a3f9ed9ad80a95557519f430076c103a9f4c6e2fc8b9800"
  license "GPL-3.0-only"
  head "https://github.com/Lakr233/LookInside.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on xcode: ["15.3", :build]
  depends_on :macos

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "lookinside"
    bin.install ".build/release/lookinside"
    generate_completions_from_executable(bin/"lookinside", "--generate-completion-script")
  end

  test do
    assert_match "OVERVIEW: Inspect debuggable app targets from the command line.",
                 shell_output("#{bin}/lookinside --help")
  end
end

class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https://joker-lang.org/"
  url "https://github.com/candid82/joker/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "8744e077e420a40a78c215fe9c61adad2aa59e8a985ec5d59aeb75f93b2706f3"
  license "EPL-1.0"
  head "https://github.com/candid82/joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d3dd3f5c3079375a0c270b02ed15dcd70e2b3b1c961339316a6c372b097ddd67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45f922906c1e3e0b22ab4c7dd32c66b8ac7e0592108fce64ecc89e0845a9f7df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f311bf231ff5825e3142c472693279006ba5c1fbdec8c69b40fe17b0bf4484de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58313fc78a9229e99bc802cbd89d70f750cd93e26b560b68fbf0577be0382d18"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c99770603ec565d3f94b6b1d83fe3ac27267a543d437fe647677f7c59b970b8"
    sha256 cellar: :any_skip_relocation, ventura:        "cbb4b1ee7c4cef4f043361b73086d695a1406198ff06cdf37e49e7f53c11daa2"
    sha256 cellar: :any_skip_relocation, monterey:       "703526cbbde67f9eea2850ea7c8ef7c6dd5b4b537a45371b73f307afd4677c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd2f8a60afb0bba85d14fb489a94481076b07b3eae3a4e3a790a43460da7b1fc"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args
  end

  test do
    test_file = testpath/"test.clj"
    test_file.write <<~EOS
      (ns brewtest)
      (defn -main [& args]
        (let [a 1]))
    EOS

    system bin/"joker", "--format", test_file
    output = shell_output("#{bin}/joker --lint #{test_file} 2>&1", 1)
    assert_match "Parse warning: let form with empty body", output
    assert_match "Parse warning: unused binding: a", output

    assert_match version.to_s, shell_output("#{bin}/joker -v 2>&1")
  end
end

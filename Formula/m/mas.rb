class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  stable do
    url "https://github.com/mas-cli/mas.git",
        tag:      "v7.0.0",
        revision: "7c70ffdfd9f71a654300a78b3b627782e6abe1b4"

    # Backport to fix build with Swift 6.4
    on_tahoe :or_newer do
      patch do
        url "https://github.com/mas-cli/mas/commit/21a7eff7905fbc2daf79150287a6eb17496d1667.patch?full_index=1"
        sha256 "e5b02ff06093c0f9f8a2c1eaea91aa5834ec7bc95ced6ab50f2e2b2e6306d319"
        type :backport
      end
      patch :DATA # https://github.com/mas-cli/mas/commit/377a1e7147b29885b5370fe03f370421dff2ad2e
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "641455eac9e2dfeaa0cff4238d4d644f6c2b91d25492e95c1ebc4461967eab97"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "294b2bb9fa19e6b395129d792fc5880b326906268d4ad023259e9aa9dee85a93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e1586d7240b2e3bfada5528fc18da035adbafdda2a55d4b69a00a272eedf88c"
    sha256 cellar: :any,                 arm64_sonoma:      "3a7a9c6e7042ac3db18357200989a9ee89f730b067593445ec4d556e425a3eca"
    sha256 cellar: :any,                 sonoma:            "53be6dd8eb7dcb6f930653f901c48ceea0602aa4584681faf92ffa35679bd1db"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sequoia # swift 6.2+
  uses_from_macos "jq", since: :sequoia

  on_sequoia :or_newer do
    depends_on xcode: ["26.0", :build]
  end

  # Test looks up an app on itunes.apple.com
  allow_network_access! :test

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    ENV["MAS_DIRTY_INDICATOR"] = ""
    system "Scripts/build", "#{tap&.name}/#{name}", "--disable-sandbox", "-c", "release"
    (libexec/"bin").install ".build/release/mas"
    bin.install "Scripts/mas"
    system "swift", "package", "--disable-sandbox", "generate-manual"
    man1.install ".build/plugins/GenerateManual/outputs/mas/mas.1"
    bash_completion.install "contrib/completion/mas.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end

__END__
diff --git a/Sources/mas/Utilities/Output/Printer.swift b/Sources/mas/Utilities/Output/Printer.swift
index bf35ec1c3239da502ffc12bb9c48b368af2b88df..412cd17d28d72ead8de3c3d979ca1a53454e2758 100644
--- a/Sources/mas/Utilities/Output/Printer.swift
+++ b/Sources/mas/Utilities/Output/Printer.swift
@@ -116,10 +116,10 @@ struct Printer {
 	}
 
 	private func print(_ items: [String], separator: String, terminator: String, to fileHandle: FileHandle) {
-		unsafe items.joined(separator: separator)
+		try? unsafe items.joined(separator: separator)
 			.appending(terminator)
 			.utf8
-			.withContiguousStorageIfAvailable { try? unsafe fileHandle.write(contentsOf: unsafe $0) }
+			.withContiguousStorageIfAvailable(fileHandle.write(contentsOf:))
 	}
 
 	private func print(

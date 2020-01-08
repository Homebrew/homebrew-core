class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.124.1",
      :revision => "c63a57eaa05d79c619cfc9825e973006bb59bfc0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf499ce12c2129b0c0c57c0e0bd9d7e31219c214539cafb44ec6f5097db1172f" => :catalina
    sha256 "2dc05e25bcaaecf83e1e67939f6713e8c3e2279f33de36f021882a50e588073e" => :mojave
    sha256 "23b762ba06b11c8953ee5f190ebd9d8b478e0805a708081497f6e43723b97b22" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             "-o", bin/"goreleaser"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end

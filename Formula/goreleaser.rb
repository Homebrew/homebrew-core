class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.124.1",
      :revision => "c63a57eaa05d79c619cfc9825e973006bb59bfc0"

  bottle do
    cellar :any_skip_relocation
    sha256 "49cda889282dce42baa55628969db59210d848c5c2de9db56ae857ac9d8fcda2" => :catalina
    sha256 "fd58567137658884f666813881262de92a752fcfb2bab7f0b349e52968a9759c" => :mojave
    sha256 "5a5c4c5efabb1a76f11a60c8815d4da6743ec3fecf0a71b44a76e260f7203e28" => :high_sierra
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

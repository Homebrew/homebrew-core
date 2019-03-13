class Enonic < Formula
  desc "Command-line interface for Enonic XP"
  homepage "https://enonic.com/"
  url "https://github.com/enonic/enonic-cli.git",
      :tag      => "1.0.0",
      :revision => "4d549122f2f0b137bd801a3b8ddb24a00a083376"

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    revision = Utils.popen_read("git rev-parse HEAD").strip
    today = Date.today
    dir = buildpath/"src/github.com/enonic/enonic-cli"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-X main.version=#{version} -X main.commit=#{revision} -X main.date=#{today}", "-o", bin/"enonic", "./internal/app/cli.go"
    end
  end

  test do
    assert_match "Enonic CLI version #{version}", pipe_output("#{bin}/enonic -v")
  end
end


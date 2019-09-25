class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.118.1",
      :revision => "eb1a122199bc2917ffa21bb8a41f38485a14824e"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d0658cef5938131e7518fca46711a8f45c9c96f669772ee293360d7f2f038a8" => :mojave
    sha256 "a916f6eed95efd14d22e2545390228145466bc6a00c5357d6f26d72dbe286492" => :high_sierra
    sha256 "10dd4c19547ab2f8936f744033a42234f8d06f8315d3daaf6bf1b4182659011f" => :sierra
  end

  depends_on "go" => :build

  # Should be removed in the next release
  patch do
    url "https://github.com/goreleaser/goreleaser/pull/1154.patch?full_index=1"
    sha256 "a68a0c56938136b419e13138a91e008d30be90195e2fcef4b9337637b50f56bf"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/goreleaser/goreleaser"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
      system "go", "build", "-ldflags",
                   "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
                   "-o", bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end

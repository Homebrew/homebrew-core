class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.118.1",
      :revision => "eb1a122199bc2917ffa21bb8a41f38485a14824e"

  bottle do
    cellar :any_skip_relocation
    sha256 "61d342ff11d647dd6d653dc8113e8d28da8116a3cc5484c0c0a17d68a8a5c5d1" => :mojave
    sha256 "9c1ca543e1574a95dc860291f80b56a8df0c9e02ce57dcaa92acd4f44c695852" => :high_sierra
    sha256 "125f2c4ff2996408820f8c7fedf290df2c5baa96a9cd11489412177b5d458193" => :sierra
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

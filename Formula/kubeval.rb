require "language/go"

class Kubeval < Formula
  desc "Validates Kubernetes configuration files"
  homepage "https://github.com/garethr/kubeval"
  url "https://github.com/garethr/kubeval.git",
      :tag => "0.6.0",
      :revision => "4406f51d632038699ec49496aef233a7d7e4bffc"
  head "https://github.com/garethr/kubeval.git"

  depends_on "glide" => :build
  depends_on "go" => :build

  go_resource "github.com/fsnotify/fsnotify" do
    url "https://github.com/fsnotify/fsnotify.git",
        :revision => "4da3e2cfbabc9f751898f250b49f2439785783a1"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
        :revision => "8f6b1344a92ff8877cf24a5de9177bf7d0a2a187"
  end

  go_resource "github.com/magiconair/properties" do
    url "https://github.com/magiconair/properties.git",
        :revision => "be5ece7dd465ab0765a9682137865547526d1dfb"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
        :revision => "d0303fe809921458f417bcf828397a65db30a7e4"
  end

  go_resource "github.com/pelletier/go-toml" do
    url "https://github.com/pelletier/go-toml.git",
        :revision => "9c1b4e331f1e3d98e72600677699fbe212cd6d16"
  end

  go_resource "github.com/spf13/afero" do
    url "https://github.com/spf13/afero.git",
        :revision => "36f8810e2e3d7eeac4ac05b57f65690fbfba62a2"
  end

  go_resource "github.com/spf13/cast" do
    url "https://github.com/spf13/cast.git",
        :revision => "acbeb36b902d72a7a4c18e8f3241075e7ab763e4"
  end

  go_resource "github.com/spf13/jwalterweatherman" do
    url "https://github.com/spf13/jwalterweatherman.git",
        :revision => "0efa5202c04663c757d84f90f5219c1250baf94f"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "2d6f6f883a06fc0d5f4b14a81e4c28705ea64c15"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "ac87088df8ef557f1e32cd00ed0b6fbc3f7ddafb"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    (buildpath/"src/github.com/garethr/kubeval/").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/garethr/kubeval" do
      system "glide", "install"
      buildtime = Utils.popen_read("date", "-u", "+%Y-%m-%d %I:%M:%S %Z")
      buildversion = Utils.popen_read("git", "describe", "--abbrev=0", "--tags")
      buildsha = Utils.popen_read("git", "rev-parse", "HEAD")
      ldflags = %W[
        -X \"github.com/garethr/kubeval/version.BuildTime=#{buildtime.chomp}\"
        -X \"github.com/garethr/kubeval/version.BuildVersion=#{buildversion.chomp}\"
        -X \"github.com/garethr/kubeval/version.BuildSHA=#{buildsha.chomp}\"
      ]
      system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"kubeval"
      pkgshare.install "fixtures/invalid.yaml"
      prefix.install_metafiles
    end
  end

  test do
    output = pipe_output("#{bin}/kubeval", (pkgshare/"invalid.yaml").read, 1)
    assert_match "Expected: integer, given: string", output
  end
end

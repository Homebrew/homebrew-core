class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      :tag      => "v0.117.2",
      :revision => "2c08ab87a13ce4a70cf89a691fbbc46c7da6c2e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "277eec4f91d832f7866e4f4301f3415213e23db3a7e0099e99f3984e947d6107" => :mojave
    sha256 "d9c87ed8a8e70af624181baf2a10555c32eab1500542ca38f0ce656a5ea41582" => :high_sierra
    sha256 "fd81544342d78c0f6033dd02b166ac66facece3bb6a99ee684fd3d0dbdaff78a" => :sierra
  end

  depends_on "go" => :build


  # Remove this patch in the next version.
  # https://github.com/goreleaser/goreleaser/pull/1141
  patch :DATA

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

__END__
diff --git a/go.mod b/go.mod
index 6cecfdd..81ce87d 100644
--- a/go.mod
+++ b/go.mod
@@ -1,5 +1,7 @@
 module github.com/goreleaser/goreleaser

+go 1.12
+
 require (
        code.gitea.io/gitea v1.10.0-dev.0.20190711052757-a0820e09fbf7
        code.gitea.io/sdk/gitea v0.0.0-20190802154435-bbad0d915e44
@@ -25,6 +27,10 @@ require (
        golang.org/x/oauth2 v0.0.0-20190402181905-9f3314589c9a
        golang.org/x/sync v0.0.0-20190423024810-112230192c58
        golang.org/x/sys v0.0.0-20190626221950-04f50cda93cb // indirect
+       golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7
        gopkg.in/alecthomas/kingpin.v2 v2.2.6
        gopkg.in/yaml.v2 v2.2.2
 )
+
+// related to an invalid pseudo version in code.gitea.io/gitea v1.10.0-dev.0.20190711052757-a0820e09fbf7
+replace github.com/go-macaron/cors => github.com/go-macaron/cors v0.0.0-20190418220122-6fd6a9bfe14e
diff --git a/go.sum b/go.sum
index 3882d42..2a66a73 100644
--- a/go.sum
+++ b/go.sum
@@ -131,7 +131,7 @@ github.com/go-logfmt/logfmt v0.4.0/go.mod h1:3RMwSq7FuexP4Kalkev3ejPJsZTpXXBr9+V
 github.com/go-macaron/binding v0.0.0-20160711225916-9440f336b443/go.mod h1:u+H6rwW+HQwUL+w5uaEJSpIlVZDye1o9MB4Su0JfRfM=
 github.com/go-macaron/cache v0.0.0-20151013081102-561735312776/go.mod h1:hHAsZm/oBZVcY+S7qdQL6Vbg5VrXF6RuKGuqsszt3Ok=
 github.com/go-macaron/captcha v0.0.0-20190710000913-8dc5911259df/go.mod h1:j9TJ+0nwUOWBvNnm0bheHIPFf3cC62EQo7n7O6PbjZA=
-github.com/go-macaron/cors v0.0.0-20190309005821-6fd6a9bfe14e9/go.mod h1:utmMRnVIrXPSfA9MFcpIYKEpKawjKxf62vv62k4707E=
+github.com/go-macaron/cors v0.0.0-20190418220122-6fd6a9bfe14e/go.mod h1:utmMRnVIrXPSfA9MFcpIYKEpKawjKxf62vv62k4707E=
 github.com/go-macaron/csrf v0.0.0-20180426211211-503617c6b372/go.mod h1:oZGMxI7MBnicI0jJqJvH4qQzyrWKhtiKxLSJKHC+ydc=
 github.com/go-macaron/i18n v0.0.0-20160612092837-ef57533c3b0f/go.mod h1:MePM/dStkAh+PNzAdNSNl4SGDM2EZvZGken+KpJhM7s=
 github.com/go-macaron/inject v0.0.0-20160627170012-d8a0b8677191/go.mod h1:VFI2o2q9kYsC4o7VP1HrEVosiZZTd+MVT3YZx4gqvJw=
@@ -440,6 +440,8 @@ golang.org/x/tools v0.0.0-20190422233926-fe54fb35175b/go.mod h1:LCzVGOaR6xXOjkQ3
 golang.org/x/tools v0.0.0-20190620154339-431033348dd0/go.mod h1:/rFqwRUd4F7ZHNgwSSTFct+R/Kf4OFW1sUzUTQQTgfc=
 golang.org/x/xerrors v0.0.0-20190410155217-1f06c39b4373 h1:PPwnA7z1Pjf7XYaBP9GL1VAMZmcIWyFz7QCMSIIa3Bg=
 golang.org/x/xerrors v0.0.0-20190410155217-1f06c39b4373/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0=
+golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7 h1:9zdDQZ7Thm29KFXgAX/+yaf3eVbP7djjWp/dXAppNCc=
+golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod h1:I/5z698sn9Ka8TeJc9MKroUUfqBBauWjQqLJ2OPfmY0=
 google.golang.org/api v0.3.1/go.mod h1:6wY9I6uQWHQ8EM57III9mq/AjF+i8G65rmVagqKMtkk=
 google.golang.org/api v0.3.2/go.mod h1:6wY9I6uQWHQ8EM57III9mq/AjF+i8G65rmVagqKMtkk=
 google.golang.org/api v0.5.0 h1:lj9SyhMzyoa38fgFF0oO2T6pjs5IzkLPKfVtxpyCRMM=
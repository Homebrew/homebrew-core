require "language/go"

class GitAnnexRemoteB2 < Formula
  desc "git-annex special remote for Backblaze's B2"
  homepage "https://github.com/encryptio/git-annex-remote-b2"
  head "https://github.com/encryptio/git-annex-remote-b2.git"

  depends_on "go" => :build
  depends_on "git-annex"

  go_resource "github.com/encryptio/go-git-annex-external" do
    url "https://github.com/encryptio/go-git-annex-external.git",
        :revision => "578cf1ff59fde073520df8e770532f317dd83776"
  end

  go_resource "gopkg.in/kothar/go-backblaze.v0" do
    url "https://github.com/kothar/go-backblaze.git",
        :revision => "702d4e7eb465dc61b7e320d649f2250d880af512"
  end

  go_resource "github.com/google/readahead" do
    url "https://github.com/google/readahead.git",
        :revision => "eaceba16903255cb149d1efc316f6cc83d765268"
  end

  go_resource "github.com/pquerna/ffjson" do
    url "https://github.com/pquerna/ffjson.git",
        :revision => "aa0246cd15f76c96de6b96f22a305bdfb2d1ec02"
  end

  go_resource "github.com/golang/glog" do
    url "https://github.com/golang/glog.git",
        :revision => "23def4e6c14b4da8ac2ed8007337bc5eb5007998"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/encryptio/git-annex-remote-b2").mkpath
    ln_s buildpath, buildpath/"src/github.com/encryptio/git-annex-remote-b2"
    system "go", "build", "-o", bin/"git-annex-remote-b2"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/git-annex-remote-b2") do |stdin, stdout, _|
      stdin.write("INITREMOTE")
      stdin.close
      assert_equal "VERSION 1\n", stdout.read
    end
  end
end

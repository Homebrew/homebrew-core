require "language/go"

class FlintChecker < Formula
  desc "Check your project for common sources of contributor friction."
  homepage "https://github.com/pengwynn/flint"
  url "https://github.com/pengwynn/flint.git",
      :tag => "v0.0.4",
      :revision => "393190ab5fa61e442b82ba1a4b54135c1fcbcd22"

  depends_on "go" => :build

  go_resource "github.com/octokit/go-octokit" do
    url "https://github.com/octokit/go-octokit.git",
        :revision => "b50cbe61aa4f09744c02b9d90fae9a3144bed005"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "a14c5b47c7efa4ff80cc42e1079a34b4756f2311"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "244daf889417d54d654735b6e669dec565b40696"
  end

  go_resource "github.com/fhs/go-netrc" do
    url "https://github.com/fhs/go-netrc.git",
        :revision => "4422b68c9c934b03e8e53ef18c8c8714542def7e"
  end

  go_resource "github.com/jingweno/go-sawyer" do
    url "https://github.com/jingweno/go-sawyer.git",
        :revision => "1999ae5763d678f3ce1112cf1fda7c7e9cf2aadf"
  end

  go_resource "github.com/jtacoma/uritemplates" do
    url "https://github.com/jtacoma/uritemplates.git",
        :revision => "0a85813ecac22e3cbe916ab9480b33f2f4a06b2e"
  end
  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/pengwynn").mkpath
    ln_sf buildpath, buildpath/"src/github.com/pengwynn/flint"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"flint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flint --version", 0)

    shell_output("#{bin}/flint", 2)

    (testpath/"README.md").write("# Readme")
    (testpath/"CONTRIBUTING.md").write("# Contributing Guidelines")
    (testpath/"LICENSE").write("License")
    shell_output("#{bin}/flint", 1)

    (testpath/"script").mkpath
    (testpath/"script/bootstrap").write("Bootstrap Script")
    (testpath/"script/test").write("Test Script")
    shell_output("#{bin}/flint", 0)
  end
end

# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Appcu < Formula
  desc "appcu 是一款用于检查并更新 macOS 上应用的 CLI 工具。appcu is a CLI tool for checking and updating applications on macOS."
  homepage "https://github.com/ChengLuffy/application_check_update"
  url "https://github.com/ChengLuffy/application_check_update/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "4afdfab0bd40603f9e9522a750ad87f570f39fa83d9318b8b1f93996d66ce9a8"
  license "MIT"


  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"appcu", "--version"
  end
end

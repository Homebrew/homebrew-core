# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Kubepod < Formula
  desc "List/Search pods faster in kubectl"
  homepage "https://github.com/kdthanvi/kubepod"
  url "https://github.com/kdthanvi/kubepod/archive/v1.0.0.tar.gz"
  sha256 "84dbe84e83d9d1445631978f54f93c3d9d592e518b2d52848413696674cb56e2"
  # depends_on "cmake" => :build

  bottle :unneeded
 
  option "with-short-names", "link as \"kpod\" instead"
  depends_on "grep"
  depends_on "kubernetes-cli" => :recommended

  def install
	bin.install "kubepod"  => build.with?("short-names") ? "kpod" : "kubepod"
  end

  test do
	assert_match "USAGE:", shell_output("#{bin}/kubepod -h 2>&1")  
  end
end

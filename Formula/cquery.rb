class Cquery < Formula
  desc "C/C++ language server"
  homepage "https://github.com/cquery-project/cquery"
  # pull from git tag to get submodules
  url "https://github.com/cquery-project/cquery.git", :tag => "v20180302",
                                                      :revision => "f3e9e756e182b122bef8826a77047f6ccf5529b6"
  head "https://github.com/cquery-project/cquery.git"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system bin/"cquery", "--test-unit"
  end
end

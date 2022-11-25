class Grantlee < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://github.com/steveire/grantlee"
  url "https://github.com/steveire/grantlee/releases/download/v5.3.1/grantlee-5.3.1.tar.gz"
  sha256 "ba288ae9ed37ec0c3622ceb40ae1f7e1e6b2ea89216ad8587f0863d64be24f06"
  license "LGPL-2.1-or-later"
  head "https://github.com/steveire/grantlee.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build

  depends_on "qt@5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--build", "build", "--target", "docs"

    (pkgshare/"doc").install Dir["build/apidox/*"]
    pkgshare.install "examples"
  end

  test do
    args = %W[
      -D Qt5_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5
      -D Qt5Gui_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Gui
      -D Qt5Sql_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Sql
      -D Qt5Widgets_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Widgets
    ]

    # Other examples require qt-webkit. We doesn't test execution because they're GUI-only apps.
    %w[books
       codegen
       textedit].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *std_cmake_args, *args
        system "cmake", "--build", "."
      end
    end
  end
end

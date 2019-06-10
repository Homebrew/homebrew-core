class MarbleDev < Formula
  desc "Source installation of KDE Marlbe for development purposes"
  homepage "https://marble.kde.org/"
  url "git://anongit.kde.org/marble.git", :branch => "Applications/19.04"
  version "19.04"
  depends_on "cmake" => :build
  depends_on "qt"

  def install
    args = std_cmake_args + %w[
      -DWITH_KF5=FALSE
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "-j"
      system "make", "install"
    end
  end

  test do
    system "true"
  end
end

class LibkainjowMustache < Formula
  desc "Mustache text templates for modern C++ (header-only)"
  homepage "https://github.com/kainjow/Mustache"
  url "https://github.com/kainjow/Mustache/archive/v4.1.tar.gz"
  sha256 "acd66359feb4318b421f9574cfc5a511133a77d916d0b13c7caa3783c0bfe167"
  license "BSL-1.0"

  def install
    (include/"kainjow").mkpath
    (include/"kainjow").install "mustache.hpp"
  end

  test do
    system "test", "-e", "#{include}/kainjow/mustache.hpp"
  end
end

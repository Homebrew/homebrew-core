class Protozero < Formula
  desc "Minimalistic protocol buffer decoder and encoder in C++"
  homepage "https://github.com/mapbox/protozero"
  url "https://github.com/mapbox/protozero/archive/v1.3.0.tar.gz"
  sha256 "85f9238fa662ff06a1e364f1461846a9d377846274e7f98407307e31086cab2b"

  def install
    (include/"protozero").install Dir["include/protozero/*"]
  end

  test do
    files = ["byteswap.hpp", "config.hpp", "exception.hpp",
             "pbf_builder.hpp", "pbf_message.hpp", "pbf_reader.hpp",
             "pbf_writer.hpp", "types.hpp", "varint.hpp", "version.hpp"]
    files.each do |f|
      assert_equal(File.exist?("#{include}/protozero/#{f}"), true)
    end
  end
end

class Libtorch < Formula
  desc "An open source deep learning platform that provides a seamless path from research prototyping to production deployment."
  homepage "https://pytorch.org/"
  url "https://download.pytorch.org/libtorch/cpu/libtorch-macos-1.0.0.zip"
  sha256 "fe6be5edcc77a7853eadff7bed82955200512810b415150ca2c49fbd7c987c6d"

  bottle :unneeded

  def install
    include.install "include/ATen" => "ATen"
    include.install "include/c10" => "c10"
    include.install "include/caffe2" => "caffe2"
    include.install "include/pybind11" => "pybind11"
    include.install "include/TH" => "TH"
    include.install "include/torch" => "torch"
    lib.install "lib/libbenchmark.a"
    lib.install "lib/libbenchmark_main.a"
    lib.install "lib/libc10.dylib"
    lib.install "lib/libcaffe2.dylib"
    lib.install "lib/libcaffe2_detectron_ops.dylib"
    lib.install "lib/libcaffe2_module_test_dynamic.dylib"
    lib.install "lib/libcaffe2_observers.dylib"
    lib.install "lib/libcaffe2_protos.a"
    lib.install "lib/libclog.a"
    lib.install "lib/libcpuinfo.a"
    lib.install "lib/libgtest.a"
    lib.install "lib/libgtest_main.a"
    lib.install "lib/libmkldnn.dylib"
    lib.install "lib/libnnpack.a"
    lib.install "lib/libnnpack_reference_layers.a"
    lib.install "lib/libonnx.a"
    lib.install "lib/libonnx_proto.a"
    lib.install "lib/libonnxifi.dylib"
    lib.install "lib/libonnxifi_dummy.dylib"
    lib.install "lib/libonnxifi_loader.a"
    lib.install "lib/libpthreadpool.a"
    lib.install "lib/libqnnpack.a"
    lib.install "lib/libshm.dylib"
    lib.install "lib/libtorch.1.dylib"
    lib.install "lib/libtorch.dylib"
    lib.install "lib/libtorch_python.dylib"
  end
  test do
    system "false"
  end
end

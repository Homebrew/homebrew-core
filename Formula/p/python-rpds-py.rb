class PythonRpdsPy < Formula
  desc "Python bindings to Rust's persistent data structures"
  homepage "https://github.com/crate-py/rpds"
  url "https://files.pythonhosted.org/packages/77/5a/0c82d0ef1322227e8e997dbbd3d4e235383d51c299dbdfd2fed2625971b0/rpds_py-0.10.0.tar.gz"
  sha256 "e36d7369363d2707d5f68950a64c4e025991eb0177db01ccb6aa6facae48b69f"
  license "MIT"

  depends_on "maturin" => :build
  depends_on "rust" => :build
  depends_on "python@3.11"

  def python
    "python3.11"
  end

  def install
    system python, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system python, "-c", <<~PYTHON
      from rpds import HashTrieMap, HashTrieSet, List

      m = HashTrieMap({"foo": "bar", "baz": "quux"})
      print(m.get("foo"))

      s = HashTrieSet({"foo", "bar", "baz", "quux"})
      print(s.remove("foo"))

      l = List([1, 3, 5])
      print(l.push_front(3))
    PYTHON
  end
end
